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
        // Отримуємо параметри з запиту
        String fileName = request.getParameter("fileName");
        String newExtension = request.getParameter("extension");

        // Викликаємо зовнішній скрипт з параметрами
        String scriptPath = getServletContext().getRealPath("/") + "WEB-INF/scripts/change_extension.sh";
        ProcessBuilder pb = new ProcessBuilder("bash", scriptPath, fileName, newExtension);
        Process p = pb.start();

        // Зчитуємо результат виконання скрипта
        BufferedReader reader = new BufferedReader(new InputStreamReader(p.getInputStream()));
        String line = null;
        StringBuilder sb = new StringBuilder();
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }

        // Обробляємо результат виконання скрипта
        String result = sb.toString();
        if (result.equals("success")) {
            response.getWriter().write("Success.");
        } else {
            response.getWriter().write("Error.");
        }
    }
}