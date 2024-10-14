<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%

    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String username = (String) session.getAttribute("username");
    String userRole = (String) session.getAttribute("userRole");
    if (!userRole.equals("client")) {
        response.sendRedirect("login.jsp");
        return;
    }

%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Match AFM</title>
    <style>
        body {
            font-family: 'Helvetica Neue', Arial, sans-serif;
            background-color: #f4f4f9;
            color: #333;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 75%;
            margin: 0 auto;
            padding: 25px;
            position: relative;
            background: #ffffff;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        h1 {
            color: #444;
            text-align: center;
        }

        form {
            background: #ffffff;
            padding: 15px;
            margin-bottom: 15px;
            border-radius: 5px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        label {
            display: block;
            margin-bottom: 6px;
            font-weight: bold;
        }

        input[type="text"],
        button {
            width: calc(100% - 22px);
            padding: 10px;
            margin-bottom: 12px;
            border: 1px solid #b6a7a3;
            border-radius: 4px;
            box-sizing: border-box;
        }

        button {
            background: #5bc0de;
            color: #fff;
            cursor: pointer;
            border: none;
            font-size: 16px;
            padding: 10px;
            margin: 0;
            transition: background-color 0.3s;
        }

        button:hover {
            background: #31b0d5;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Σύνδεση Λογαριασμού με ΑΦΜ</h1>
    <form action="clientAction" method="post">
        <input type="hidden" name="action" value="matchAFM">
        <label for="afm">Εισάγετε το ΑΦΜ σας:</label>
        <input type="text" id="afm" name="afm" required>
        <button type="submit">Υποβολή</button>
    </form
