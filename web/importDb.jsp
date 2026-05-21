<%@ page import="java.io.*, java.sql.*, util.DBConnection" %>

<%
    out.println("<h3>Starting database initialization...</h3>");
    try (Connection conn = DBConnection.getConnection();
         Statement stmt = conn.createStatement()) {
        
        String[] sqlFiles = { "/WEB-INF/kalpana_travels.sql", "/WEB-INF/migration_v2.sql" };
        
        for (String file : sqlFiles) {
            out.println("<h4>Processing file: " + file + "</h4>");
            InputStream is = application.getResourceAsStream(file);
            if (is == null) {
                out.println("<p style='color:red;'>File not found: " + file + "</p>");
                continue;
            }
            
            BufferedReader reader = new BufferedReader(new InputStreamReader(is, "UTF-8"));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                // Skip empty lines and single-line comments
                if (line.trim().isEmpty() || line.trim().startsWith("--") || line.trim().startsWith("#")) {
                    continue;
                }
                sb.append(line).append("\n");
            }
            
            // Basic parsing of SQL statements by delimiter ';'
            // Note: This is a simple parser, but works for the exported dump format
            String[] queries = sb.toString().split(";");
            int successCount = 0;
            int errorCount = 0;
            
            for (String query : queries) {
                String q = query.trim();
                if (q.isEmpty()) {
                    continue;
                }
                try {
                    stmt.execute(q);
                    successCount++;
                } catch (SQLException ex) {
                    out.println("<p style='color:orange;'>Warning executing: " + q.substring(0, Math.min(q.length(), 60)) + "... <br/>Error: " + ex.getMessage() + "</p>");
                    errorCount++;
                }
            }
            out.println("<p style='color:green;'>Completed " + file + ": " + successCount + " successful, " + errorCount + " ignored/errors.</p>");
        }
        
        out.println("<h3 style='color:green;'>Database setup completed successfully!</h3>");
        
    } catch (Exception e) {
        out.println("<h3 style='color:red;'>Fatal Error: " + e.getMessage() + "</h3>");
        e.printStackTrace(new PrintWriter(out));
    }
%>
