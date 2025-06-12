<%@ page language="java" pageEncoding="UTF-8"%>
<%
    String message = request.getParameter("message");
    String type = request.getParameter("type");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>GCG 회원가입</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class'
        }
    </script>
    <style>
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @keyframes slideInScale {
            from {
                opacity: 0;
                transform: scale(0.9);
            }
            to {
                opacity: 1;
                transform: scale(1);
            }
        }
        
        .animate-fadeInUp {
            animation: fadeInUp 0.6s ease-out;
        }
        
        .animate-slideInScale {
            animation: slideInScale 0.8s ease-out;
        }
    </style>
</head>
<body class="min-h-screen bg-gray-100 dark:bg-gray-900 flex items-center justify-center font-sans p-4 transition-colors duration-300">
    <div class="w-full max-w-md bg-white dark:bg-gray-800 rounded-2xl shadow-2xl p-8 animate-slideInScale border border-gray-200 dark:border-gray-700">
        <div class="text-center mb-8">
            <h1 class="text-3xl font-bold text-black dark:text-white mb-2" style="font-family: cursive;">GCG</h1>
            <h2 class="text-gray-600 dark:text-gray-400 text-lg">새로운 계정을 만들어보세요</h2>
        </div>

        <% if (message != null && !message.trim().isEmpty()) { %>
        <div class="mb-6 p-4 rounded-lg <%= "error".equals(type) ? "bg-red-50 border border-red-200 text-red-700 dark:bg-red-900/20 dark:border-red-800 dark:text-red-400" : "bg-green-50 border border-green-200 text-green-700 dark:bg-green-900/20 dark:border-green-800 dark:text-green-400" %>">
            <div class="flex items-center">
                <span class="text-xl mr-2"><%= "error".equals(type) ? "⚠️" : "✅" %></span>
                <span><%= message %></span>
            </div>
        </div>
        <% } %>

        <form action="signup" method="post" class="space-y-6">
            <div class="space-y-4">
                <div class="relative">
                    <input type="text" 
                           name="username" 
                           placeholder="아이디" 
                           required
                           class="w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500 outline-none transition-all duration-200 placeholder-gray-400 bg-white dark:bg-gray-700 text-black dark:text-white">
                    <div class="text-xs text-gray-500 dark:text-gray-400 mt-1">4-20자의 영문, 숫자만 사용 가능합니다</div>
                </div>
                
                <div class="relative">
                    <input type="email" 
                           name="email" 
                           placeholder="이메일" 
                           required
                           class="w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500 outline-none transition-all duration-200 placeholder-gray-400 bg-white dark:bg-gray-700 text-black dark:text-white">
                    <div class="text-xs text-gray-500 dark:text-gray-400 mt-1">유효한 이메일 주소를 입력해주세요</div>
                </div>
                
                <div class="relative">
                    <input type="password" 
                           name="password" 
                           placeholder="비밀번호" 
                           required
                           class="w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500 outline-none transition-all duration-200 placeholder-gray-400 bg-white dark:bg-gray-700 text-black dark:text-white">
                    <div class="text-xs text-gray-500 dark:text-gray-400 mt-1">8자 이상의 영문, 숫자, 특수문자 조합</div>
                </div>
                
                <div class="relative">
                    <input type="password" 
                           name="confirmPassword" 
                           placeholder="비밀번호 확인" 
                           required
                           class="w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500 outline-none transition-all duration-200 placeholder-gray-400 bg-white dark:bg-gray-700 text-black dark:text-white">
                </div>
            </div>

            <button type="submit" 
                    class="w-full py-3 bg-gradient-to-r from-purple-600 to-pink-600 text-white rounded-lg hover:from-purple-700 hover:to-pink-700 transition-all duration-200 font-semibold shadow-lg transform hover:scale-[1.02]">
                회원가입
            </button>
        </form>
        
        <div class="mt-6 text-center">
            <p class="text-gray-600 dark:text-gray-400">
                이미 계정이 있으신가요? 
                <a href="login.jsp" class="text-purple-600 dark:text-purple-400 hover:underline font-medium">
                    로그인
                </a>
            </p>
        </div>
        
        <div class="mt-4 text-center">
            <a href="index.jsp" class="text-xs text-gray-500 dark:text-gray-400 hover:text-purple-600 dark:hover:text-purple-400 transition-colors duration-200">
                메인 페이지로 돌아가기
            </a>
        </div>
    </div>

    <script>
        document.querySelectorAll('input').forEach(input => {
            input.addEventListener('focus', function() {
                this.parentElement.classList.add('transform', 'scale-105');
            });
            
            input.addEventListener('blur', function() {
                this.parentElement.classList.remove('transform', 'scale-105');
            });
        });

        document.querySelector('form').addEventListener('submit', function(e) {
            const password = document.querySelector('input[name="password"]').value;
            const confirmPassword = document.querySelector('input[name="confirmPassword"]').value;
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('비밀번호가 일치하지 않습니다.');
                return false;
            }
        });

        document.addEventListener('keydown', function(e) {
            if (e.ctrlKey && e.key === 'd') {
                e.preventDefault();
                document.documentElement.classList.toggle('dark');
                localStorage.setItem('theme', document.documentElement.classList.contains('dark') ? 'dark' : 'light');
            }
        });

        if (localStorage.getItem('theme') === 'dark') {
            document.documentElement.classList.add('dark');
        }
    </script>
</body>
</html>

