// Arquivo JavaScript com vulnerabilidades para teste SAST

// 1. SQL Injection vulnerability
function getUserData(userId) {
  const query = "SELECT * FROM users WHERE id = " + userId; // Vulnerable to SQL injection
  return database.query(query);
}

// 2. XSS vulnerability
function renderUserName(userName) {
  document.getElementById("user").innerHTML = userName; // Vulnerable to XSS
}

// 3. Hardcoded secret (já detectado por outras ferramentas)
const API_KEY = "sk_live_1234567890abcdefghijk";

// 4. Command Injection vulnerability
const { exec } = require("child_process");
function processFile(filename) {
  exec("ls -la " + filename); // Vulnerable to command injection
}

// 5. Insecure random number generation
function generateToken() {
  return Math.random().toString(36); // Cryptographically insecure
}

// 6. Path Traversal vulnerability
const fs = require("fs");
function readFile(filepath) {
  return fs.readFileSync("./uploads/" + filepath); // Vulnerable to path traversal
}

// 7. Eval usage (dangerous)
function processUserInput(userCode) {
  return eval(userCode); // Never use eval with user input
}

// 8. Weak crypto
const crypto = require("crypto");
function hashPassword(password) {
  return crypto.createHash("md5").update(password).digest("hex"); // MD5 is weak
}

module.exports = {
  getUserData,
  renderUserName,
  processFile,
  generateToken,
  readFile,
  processUserInput,
  hashPassword,
};
