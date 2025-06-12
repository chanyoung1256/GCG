//package servlet;
//
//import dao.UserDAO;
//import model.User;  // ← User 객체 가져오기
//import jakarta.servlet.*;
//import jakarta.servlet.http.*;
//import java.io.IOException;
//
//public class LoginServlet extends HttpServlet {
//    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        try {
//            request.setCharacterEncoding("UTF-8");
//            String username = request.getParameter("username");
//            String password = request.getParameter("password");
//
//            UserDAO dao = new UserDAO();
//            if (dao.validateUser(username, password)) {
//                // 로그인 성공 시 유저 정보 가져오기
//                User user = dao.getUserByUsername(username); // ← 이 메서드는 반드시 있어야 함
//
//                HttpSession session = request.getSession();
//                session.setAttribute("username", username);
//                session.setAttribute("user_id", user.getId());  // ★ 핵심 추가
//                session.setAttribute("username", user.getUsername()); // ✅ STRING 저장
//
//                response.sendRedirect("index.jsp");
//            } else {
//                response.sendRedirect("login.jsp?error=true");
//            }
//        } catch (Exception e) {
//            throw new ServletException(e);
//        }
//    }
//}

package servlet;

import dao.UserDAO;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            request.setCharacterEncoding("UTF-8");
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            UserDAO dao = new UserDAO();
            if (dao.validateUser(username, password)) {
                User user = dao.getUserByUsername(username);

                HttpSession session = request.getSession();
                
                session.setAttribute("username", user.getUsername());
                session.setAttribute("user_id", user.getId());
                
                if ("admin".equals(user.getUsername()) || user.isAdmin()) {
                    session.setAttribute("userRole", "admin");
                } else {
                    session.setAttribute("userRole", "user");
                }
               
                if ("admin".equals(session.getAttribute("userRole"))) {
                    response.sendRedirect("admin");
                } else {
                    response.sendRedirect("list.jsp");
                }
                
            } else {
                response.sendRedirect("login.jsp?error=true");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=server");
        }
    }
}


