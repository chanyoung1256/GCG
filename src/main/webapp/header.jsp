<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String username = (String) session.getAttribute("username");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>강원특별자치도 창업 공단 대여 플랫폼</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
	      tailwind.config = {
	        darkMode: 'class'
	      }
    </script>
    <style>
	    .text-shadow {
	        font-weight: 700;
	        font-size: 1.125rem;
	        text-shadow: 
	            0 1px 2px rgba(0, 0, 0, 0.8),
	            1px 1px 1px rgba(0, 0, 0, 0.6);
	    }
	    
	    .text-shadow-soft {
	        font-weight: 600;
	        font-size: 1rem;
	        text-shadow: 
	            0 1px 2px rgba(0, 0, 0, 0.7),
	            0 0 1px rgba(0, 0, 0, 0.5);
	    }
	    
	    .logo-text {
	        font-weight: 800;
	        font-size: 1.25rem;
	        text-shadow: 
	            0 1px 3px rgba(0, 0, 0, 0.85),
	            1px 1px 2px rgba(0, 0, 0, 0.7);
	        letter-spacing: 0.5px;
	    }
	    
	    .nav-text {
	        font-weight: 600;
	        font-size: 1.1rem;
	        text-shadow: 
	            0 1px 2px rgba(0, 0, 0, 0.75),
	            0 0 1px rgba(0, 0, 0, 0.6);
	    }
	    
	    .hover-glow:hover {
	        text-shadow: 
	            0 1px 3px rgba(0, 0, 0, 0.9),
	            0 2px 4px rgba(0, 0, 0, 0.5),
	            0 0 3px rgba(255, 255, 255, 0.2);
	        transform: translateY(-0.5px);
	    }
	    
	    .btn-shadow {
	        text-shadow: 0 1px 1px rgba(0, 0, 0, 0.6);
	    }
	</style>
</head>
<body class="bg-gray-50 text-gray-900 font-sans transition-colors duration-300 dark:bg-gray-950 dark:text-gray-100">
	<header id="main-header" class="fixed top-0 left-0 w-full h-16 bg-transparent transition-colors duration-300 text-white px-10 z-50 flex items-center">
	    <div class="w-full flex justify-between items-center px-[10%]">
	        <div class="text-lg font-bold">
	            
	            <a href="index.jsp" class="hover:underline hover:text-gray-300 logo-text hover-glow transition-all duration-300">
	                강원특별자치도 창업 공단 대여 플랫폼
	            </a>
	        </div>
	        <nav class="flex items-center gap-6 mr-[10%] text-base">
	           
	            <a href="notices.jsp" class="hover:underline nav-text hover-glow hover:text-gray-300 transition-all duration-300">공지사항</a>
	
	            <a href="community.jsp" class="hover:underline nav-text hover-glow hover:text-gray-300 transition-all duration-300">커뮤니티</a>
	            <a href="list.jsp" class="hover:underline nav-text hover-glow hover:text-gray-300 transition-all duration-300">게시물</a>
	            <% if (username == null) { %>
	                <a href="login.jsp" class="hover:underline nav-text hover-glow hover:text-gray-300 transition-all duration-300">로그인</a>
	            <% } else { %>
	                <form action="logout" method="post" class="inline">
	                    <button type="submit" class="hover:underline nav-text hover-glow hover:text-gray-300 transition-all duration-300">로그아웃</button>
	                </form>
	            <% } %>
	           
	            <button id="theme-toggle" type="button"
	                class="ml-4 px-4 py-2 rounded-lg border border-white bg-white/15 text-white hover:bg-white/25 transition-all duration-300 btn-shadow backdrop-blur-sm font-semibold hover-glow
	                       dark:bg-black/15 dark:border-gray-700 dark:text-gray-200 dark:hover:bg-black/35"
	                aria-label="테마 전환">
	                <span id="theme-toggle-icon" class="inline-block align-middle text-lg">🌙</span>
	            </button>
	        </nav>
	    </div>
	</header>


    