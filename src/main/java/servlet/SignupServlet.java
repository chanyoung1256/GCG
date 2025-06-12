//package servlet;
//
//import dao.UserDAO;
//import model.User;
//import jakarta.servlet.*;
//import jakarta.servlet.http.*;
//import java.io.IOException;
//
//public class SignupServlet extends HttpServlet {
//	protected void doPost(HttpServletRequest request, HttpServletResponse response)
//			throws ServletException, IOException {
//		try {
//			request.setCharacterEncoding("UTF-8");
//			String username = request.getParameter("username");
//			String password = request.getParameter("password");
//
//			User user = new User(username, password);
//			UserDAO dao = new UserDAO();
//			dao.insertUser(user);
//
//			response.sendRedirect("login.jsp");
//		} catch (Exception e) {
//			throw new ServletException(e);
//		}
//	}
//}
package servlet;

import dao.UserDAO;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class SignupServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setCharacterEncoding("UTF-8");
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String email = request.getParameter("email");

            if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                email == null || email.trim().isEmpty()) {
                response.sendRedirect("signup.jsp?error=empty");
                return;
            }

            UserDAO dao = new UserDAO();
            
            // 중복 체크
            if (dao.isUsernameExists(username)) {
                response.sendRedirect("signup.jsp?error=username_exists");
                return;
            }
            
            if (dao.isEmailExists(email)) {
                response.sendRedirect("signup.jsp?error=email_exists");
                return;
            }

            User user = new User(username, password, email);
            boolean success = dao.insertUser(user);

            if (success) {
                response.sendRedirect("login.jsp?signup=success");
            } else {
                response.sendRedirect("signup.jsp?error=server");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("signup.jsp?error=server");
        }
    }
}
