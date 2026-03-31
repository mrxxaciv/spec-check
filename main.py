from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import mysql.connector
import os


app = FastAPI(title="PC Specs Checker API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

def get_db():
    try:
        conn = mysql.connector.connect(
            host=os.environ.get("DB_HOST"),
            user=os.environ.get("DB_USER"),
            password=os.environ.get("DB_PASSWORD"),
            database=os.environ.get("DB_NAME"),
            port=int(os.environ.get("DB_PORT", 3306)),
            connect_timeout=10 # Prevents the app from hanging forever
        )
        return conn
    except mysql.connector.Error as err:
        print(f"Error: {err}")
        raise HTTPException(status_code=500, detail=f"Database connection failed: {err}")
    
# ── Hardware lookup endpoints ──────────────────────────────────────────────

@app.get("/api/gpus")
def list_gpus():
    db = get_db(); cur = db.cursor(dictionary=True)
    cur.execute("SELECT gpu_name, tier FROM gpu_tiers ORDER BY tier, gpu_name")
    rows = cur.fetchall(); db.close()
    return rows

@app.get("/api/cpus")
def list_cpus():
    db = get_db(); cur = db.cursor(dictionary=True)
    cur.execute("SELECT cpu_name, tier FROM cpu_tiers ORDER BY tier, cpu_name")
    rows = cur.fetchall(); db.close()
    return rows

# ── Main check endpoint ────────────────────────────────────────────────────

@app.get("/api/check")
def check_specs(gpu: str, cpu: str, ram: int, storage: int):
    db = get_db(); cur = db.cursor(dictionary=True)

    cur.execute("SELECT tier FROM gpu_tiers WHERE gpu_name = %s", (gpu,))
    gpu_row = cur.fetchone()
    if not gpu_row:
        raise HTTPException(400, f"GPU '{gpu}' not found")
    gpu_tier = gpu_row["tier"]

    cur.execute("SELECT tier FROM cpu_tiers WHERE cpu_name = %s", (cpu,))
    cpu_row = cur.fetchone()
    if not cpu_row:
        raise HTTPException(400, f"CPU '{cpu}' not found")
    cpu_tier = cpu_row["tier"]

    cur.execute("SELECT * FROM games ORDER BY title")
    games = cur.fetchall()
    db.close()

    results = []
    for g in games:
        gpu_min  = gpu_tier >= g["min_gpu_tier"]
        gpu_rec  = gpu_tier >= g["rec_gpu_tier"]
        cpu_min  = cpu_tier >= g["min_cpu_tier"]
        cpu_rec  = cpu_tier >= g["rec_cpu_tier"]
        ram_min  = ram     >= g["min_ram_gb"]
        ram_rec  = ram     >= g["rec_ram_gb"]
        stor_min = storage >= g["min_storage_gb"]
        stor_rec = storage >= g["rec_storage_gb"]

        meets_min = gpu_min and cpu_min and ram_min and stor_min
        meets_rec = gpu_rec and cpu_rec and ram_rec and stor_rec

        if meets_rec:
            status = "recommended"
        elif meets_min:
            status = "minimum"
        else:
            status = "incompatible"

        # ── NEW: Upgrade Advisor with Amazon Links ──────────
        suggestions = []
        if status == "incompatible":
            base_url = "https://www.amazon.in/s?k="
            
            if not gpu_min:
                query = f"Tier {g['min_gpu_tier']} Graphics Card".replace(" ", "+")
                suggestions.append({
                    "message": f"GPU too weak — you're Tier {gpu_tier}, need at least Tier {g['min_gpu_tier']}",
                    "link": f"{base_url}{query}"
                })
            if not cpu_min:
                query = f"Tier {g['min_cpu_tier']} Processor".replace(" ", "+")
                suggestions.append({
                    "message": f"CPU too weak — you're Tier {cpu_tier}, need at least Tier {g['min_cpu_tier']}",
                    "link": f"{base_url}{query}"
                })
            if not ram_min:
                query = f"{g['min_ram_gb']}GB DDR4 RAM".replace(" ", "+")
                suggestions.append({
                    "message": f"Not enough RAM — you have {ram}GB, need at least {g['min_ram_gb']}GB",
                    "link": f"{base_url}{query}"
                })
            if not stor_min:
                query = f"{g['min_storage_gb']}GB SSD Internal".replace(" ", "+")
                suggestions.append({
                    "message": f"Not enough storage — you have {storage}GB free, need {g['min_storage_gb']}GB",
                    "link": f"{base_url}{query}"
                })
        # ─────────────────────────────────────────────────────
        # ─────────────────────────────────────────────────────

        results.append({
            "title":       g["title"],
            "genre":       g["genre"],
            "status":      status,
            "gpu_ok":      "✅" if gpu_min else "❌",
            "cpu_ok":      "✅" if cpu_min else "❌",
            "ram_ok":      "✅" if ram_min  else "❌",
            "storage_ok":  "✅" if stor_min else "❌",
            "suggestions": suggestions,           # ← NEW field
            "details": {
                "gpu":  {"have": gpu_tier,  "min": g["min_gpu_tier"],  "rec": g["rec_gpu_tier"]},
                "cpu":  {"have": cpu_tier,  "min": g["min_cpu_tier"],  "rec": g["rec_cpu_tier"]},
                "ram":  {"have": ram,       "min": g["min_ram_gb"],    "rec": g["rec_ram_gb"]},
                "stor": {"have": storage,   "min": g["min_storage_gb"],"rec": g["rec_storage_gb"]},
            }
        })

    return {
        "user_specs": {"gpu": gpu, "gpu_tier": gpu_tier, "cpu": cpu, "cpu_tier": cpu_tier, "ram": ram, "storage": storage},
        "results": results,
        "summary": {
            "recommended":  sum(1 for r in results if r["status"] == "recommended"),
            "minimum":      sum(1 for r in results if r["status"] == "minimum"),
            "incompatible": sum(1 for r in results if r["status"] == "incompatible"),
        }
    }

@app.get("/")
def root():
    return {"status": "ok", "message": "PC Specs Checker API"}
