<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Java Telecom</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
            text-align: center;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        .login-button {
            padding: 14px 20px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .login-button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Java Telecom</h1>
    <p>Σας συνδέουμε με το κόσμο</p>
    <p>Παρακαλώ συνδεθείτε ή εγγραφείτε για να προχωρήσετε</p>
    <form action="login.jsp">
        <button type="submit" class="login-button">Σύνδεση/Εγγραφή</button>
    </form>
</div>
</body>
</html>
