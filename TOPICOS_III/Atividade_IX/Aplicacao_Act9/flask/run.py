import os
from app import create_app

app = create_app()

if __name__ == "__main__":
    host = os.getenv("PETCUIDA_HOST", "127.0.0.1")
    port = int(os.getenv("PORT", "5000"))
    debug = os.getenv("PETCUIDA_DEBUG", "0").strip().lower() in {"1", "true", "yes"}
    app.run(host=host, port=port, debug=debug)
