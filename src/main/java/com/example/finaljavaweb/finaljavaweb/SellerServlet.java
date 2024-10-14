package com.example.finaljavaweb.finaljavaweb;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/SellerServlet")
public class SellerServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(SellerServlet.class.getName());

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        LOGGER.log(Level.INFO, "Action parameter received: {0}", action);

        if (action == null || action.isEmpty()) {
            request.setAttribute("errorMessage", "Action parameter is missing or invalid");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

        Seller seller = new Seller();

        switch (action) {
            case "logout":
                response.sendRedirect("login.jsp");
                request.getSession().invalidate();
                break;
            case "insertCustomer":
                seller.insertCustomer(request, response);
                break;
            case "assignPackage":
                seller.assignPackage(request, response);
                break;
            case "issueBill":
                seller.issueBill(request, response);
                break;
            case "viewCallHistory":
                seller.viewCallHistory(request, response);
                break;
            default:
                request.setAttribute("errorMessage", "Unknown action");
                request.getRequestDispatcher("error.jsp").forward(request, response);
                break;
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        LOGGER.log(Level.INFO, "Action parameter received: {0}", action);

        if (action == null || action.isEmpty()) {
            request.setAttribute("errorMessage", "Action parameter is missing or invalid");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

        if ("viewPackages".equals(action)) {
            response.sendRedirect("AvailablePackages.jsp");
        } else if ("viewCustomers".equals(action)) {
            response.sendRedirect("viewCustomers.jsp");
        } else {
            request.setAttribute("errorMessage", "Unknown action");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}
