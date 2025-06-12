package servlet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.*;
import java.nio.file.*;

@WebServlet("/image/*")
public class ImageServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        String fileName = pathInfo.substring(1);
        
        if (fileName.contains("..") || fileName.contains("/") || fileName.contains("\\")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        String uploadPath = getServletContext().getRealPath("/uploads");
        File imageFile = new File(uploadPath, fileName);
        
        if (!imageFile.exists() || !imageFile.isFile()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        String mimeType = getServletContext().getMimeType(fileName);
        if (mimeType == null) {
            mimeType = "application/octet-stream";
        }
        response.setContentType(mimeType);
        
        response.setHeader("Cache-Control", "public, max-age=31536000");
        
        try (InputStream in = new FileInputStream(imageFile);
             OutputStream out = response.getOutputStream()) {
            
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }
}
