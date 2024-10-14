package com.example.finaljavaweb.finaljavaweb;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;
import java.sql.Connection;

public class DatabaseUtil {
    private static DataSource dataSource;

    static {
        try {
            Context initContext = new InitialContext();
            Context envContext = (Context) initContext.lookup("java:/comp/env");
            dataSource = (DataSource) envContext.lookup("jdbc/PostgresDB");
        } catch (Exception e) {
            throw new ExceptionInInitializerError("Initial DataSource lookup failed" + e);
        }
    }

    public static Connection getConnection() throws Exception {
        return dataSource.getConnection();
    }
}

