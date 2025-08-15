# Arquivo Python com vulnerabilidades para teste SAST

import os
import subprocess
import hashlib
import pickle
import sqlite3
import random
from flask import Flask, request

app = Flask(__name__)

# 1. SQL Injection vulnerability
def get_user_data(user_id):
    conn = sqlite3.connect('users.db')
    cursor = conn.cursor()
    # Vulnerable to SQL injection
    query = f"SELECT * FROM users WHERE id = {user_id}"
    cursor.execute(query)
    return cursor.fetchall()

# 2. Command Injection vulnerability
def process_file(filename):
    # Vulnerable to command injection
    os.system(f"ls -la {filename}")

# 3. Hardcoded credentials
DATABASE_PASSWORD = "admin123"  # Hardcoded password
SECRET_KEY = "super-secret-key-123"

# 4. Insecure deserialization
def load_user_data(data):
    # Vulnerable to arbitrary code execution
    return pickle.loads(data)

# 5. Weak cryptographic hash
def hash_password(password):
    # MD5 is cryptographically weak
    return hashlib.md5(password.encode()).hexdigest()

# 6. Insecure random number generation
def generate_session_id():
    # Not cryptographically secure
    return str(random.randint(1000000, 9999999))

# 7. Path Traversal vulnerability
@app.route('/file')
def read_file():
    filename = request.args.get('file')
    # Vulnerable to path traversal
    with open(f"./uploads/{filename}", 'r') as f:
        return f.read()

# 8. Shell=True in subprocess (dangerous)
def execute_command(cmd):
    # Vulnerable to command injection
    subprocess.call(cmd, shell=True)

# 9. Assert used for authentication (bad practice)
def authenticate_user(username, password):
    # Assert can be disabled in production
    assert username == "admin" and password == "secret"
    return True

# 10. Eval usage (dangerous)
def calculate_expression(expression):
    # Never use eval with user input
    return eval(expression)

if __name__ == "__main__":
    # Debug mode should not be used in production
    app.run(debug=True, host='0.0.0.0')
