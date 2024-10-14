package com.example.finaljavaweb.finaljavaweb;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet(name = "ClientServlet", value = "/clientAction")
public class ClientServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("viewBills".equals(action)) {
            Client client = new Client();
            client.viewBills(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        if ("viewBills".equals(action)) {
            Integer clientIdInt = (Integer) session.getAttribute("client_id");
            String clientId = clientIdInt != null ? String.valueOf(clientIdInt) : null;
            if (clientId != null) {
                response.sendRedirect("clientAction?action=viewBills&clientId=" + clientId);
            } else {
                response.sendRedirect("matchAFM.jsp");
            }
        } else if ("matchAFM".equals(action)) {
            Client client = new Client();
            client.matchAFM(response, request);
        } else if ("viewCallHistory".equals(action)) {
            Client client = new Client();
            client.viewCallHistory(request, response);
        } else if ("payBill".equals(action)) {
            Client client = new Client();
            client.payBill(request, response);
        }else if ("logout".equals(action)){
            response.sendRedirect("login.jsp");
            request.getSession().invalidate();


        }
    }
}
