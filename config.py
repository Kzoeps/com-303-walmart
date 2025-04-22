# config.py
import os
from dotenv import load_dotenv

# find .env in current or parent directories and load it
load_dotenv()

DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_NAME = os.getenv("DB_NAME")
