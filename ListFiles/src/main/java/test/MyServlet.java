package test;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/changeExtension")
public class MyServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getParameter("path");
        String scriptPath = getServletContext().getRealPath("/") + "app/scripts/listfiles.sh";
        ProcessBuilder pb = new ProcessBuilder("bash", scriptPath, path, newExtension);
        Process p = pb.start();
        BufferedReader reader = new BufferedReader(new InputStreamReader(p.getInputStream()));
        String line = null;
        StringBuilder sb = new StringBuilder();
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }
        String result = sb.toString();
        if (result.equals("success")) {
            response.getWriter().write("Success.");
        } else {
            response.getWriter().write("Error.");
        }
    }
}