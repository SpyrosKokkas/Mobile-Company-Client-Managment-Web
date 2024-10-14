<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%

    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String username = (String) session.getAttribute("username");
    String userRole = (String) session.getAttribute("userRole");
    if ( !userRole.equals("admin") ) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Panel</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            color: #333;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 80%;
            margin: 0 auto;
            padding: 20px;
            position: relative;
            text-align: center;
        }

        h1, h2 {
            color: #444;
            text-align: center;
        }

        button {
            padding: 10px 20px;
            margin: 10px;
            border: none;
            border-radius: 5px;
            background-color: #5c85d6;
            color: white;
            cursor: pointer;
        }

        button:hover {
            background-color: #4a73c3;
        }

        .logout-back-container {
            position: absolute;
            top: 10px;
            right: 10px;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .logout-button {
            padding: 10px 5px;
            background: #d9534f;
            color: #fff;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            font-size: 14px;
            width: 90px;
        }

        .logout-button:hover {
            background: #c9302c;
        }

        .back-button {
            padding: 8px 5px;
            background: #5bc0de;
            color: #fff;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            font-size: 14px;
            width: 90px;
        }

        .back-button:hover {
            background: #31b0d5;
        }
    </style>
</head>
<body>
<div class="logout-back-container">
    <form action="adminAction" method="post" style="margin: 0; padding: 0;">
        <input type="hidden" name="action" value="logout">
        <button type="submit" class="logout-button">Αποσύνδεση</button>
    </form>
    <form action="adminIndex" style="margin: 0; padding: 0;">
        <button type="submit" class="back-button">Επιστροφή</button>
    </form>
</div>

<h1>Πίνακας Διαχειριστών</h1>

<div class="container">
    <h2>Διαχείριση Χρηστών</h2>
    <button onclick="location.href='manageUsers.jsp'">Διαχείριση Χρηστών</button>

    <h2>Διαχείριση Πακέτων</h2>
    <button onClick="location.href='AdminPackageEdit.jsp'">Διαχείριση Πακέτων</button>
</div>
</body>
</html>
