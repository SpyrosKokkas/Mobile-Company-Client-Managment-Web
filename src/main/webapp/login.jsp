<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Page</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            font-family: Arial, sans-serif;
            background: #f0f0f0;
        }

        .login-container {
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 300px;
            text-align: center;
        }

        h2 {
            margin-bottom: 20px;
            color: #333;
        }

        .input-group {
            margin-bottom: 15px;
            text-align: left;
        }

        label {
            display: block;
            margin-bottom: 5px;
            color: #555;
        }

        input {
            width: 95%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }

        button {
            width: 100%;
            padding: 10px;
            border: none;
            border-radius: 5px;
            background: #5c85d6;
            color: #fff;
            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background: #31b0d5;
        }

    </style>
    <script>
        function setAction(action) {
            document.getElementById('action').value = action;
        }

    </script>
</head>
<body>
<div class="login-container">
    <h2>Σύνδεση</h2>
    <form action="login" method="post">
        <div class="input-group">
            <label for="username">Όνομα Χρήστη</label>
            <input type="text" id="username" name="username" required>
        </div>
        <div class="input-group">
            <label for="password">Κωδικός</label>
            <input type="password" id="password" name="password" required>
        </div>
        <input type="hidden" id="action" name="action" value="login">
        <button type="submit" onclick="setAction('login')">Σύνδεση</button>
        <div><br> Δεν έχετε λογαρισμό; Εγγραφείτε εδώ <br></div>
        <button type="submit" onclick="setAction('register')">Εγγραφή</button>
    </form>
</div>
</body>
</html>
