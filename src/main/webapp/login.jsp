<%@ page language="java" pageEncoding="UTF-8"%>
<%
    String message = request.getParameter("message");
    String type = request.getParameter("type");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>GCG 로그인</title>
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
        
        @keyframes slideInLeft {
            from {
                opacity: 0;
                transform: translateX(-50px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }
        
        .animate-fadeInUp {
            animation: fadeInUp 0.6s ease-out;
        }
        
        .animate-slideInLeft {
            animation: slideInLeft 0.8s ease-out;
        }
    </style>
</head>
<body class="min-h-screen bg-gray-100 dark:bg-gray-900 flex items-center justify-center font-sans p-4 transition-colors duration-300">
    <div class="flex w-full max-w-4xl h-auto md:h-[550px] bg-white dark:bg-gray-800 rounded-2xl overflow-hidden shadow-2xl animate-fadeInUp border border-gray-200 dark:border-gray-700">
        <div class="w-full md:w-1/2 bg-gray-50 dark:bg-gray-700 p-8 md:p-12 flex flex-col justify-center items-center animate-slideInLeft">
            <div class="w-full max-w-xs mb-8">
                <img src="test1.jpg" 
                     alt="일러스트" 
                     class="w-full h-auto rounded-lg shadow-md transform hover:scale-105 transition-transform duration-300">
            </div>
            
            <div class="text-center max-w-xs">
                <h2 class="text-xl font-semibold text-gray-800 dark:text-white mb-4">강원특별자치도 창업공단</h2>
                <p class="text-sm text-gray-600 dark:text-gray-400 leading-relaxed mb-6">
                    게시물을 작성하기 위해 로그인 부탁드립니다.
                </p>
                <div class="flex justify-center gap-2">
                    <div class="w-2 h-2 bg-purple-600 rounded-full"></div>
                    <div class="w-2 h-2 bg-gray-400 rounded-full"></div>
                    <div class="w-2 h-2 bg-gray-400 rounded-full"></div>
                </div>
            </div>
        </div>

        <div class="w-full md:w-1/2 p-8 md:p-12 flex flex-col justify-center bg-white dark:bg-gray-800">
            <div class="w-full max-w-sm mx-auto">
                <div class="text-center mb-8">
                    <h1 class="text-3xl font-bold text-black dark:text-white mb-2" style="font-family: cursive;">GCG</h1>
                    <h2 class="text-gray-600 dark:text-gray-400 text-lg">Welcome to GCG</h2>
                </div>

                <% if (message != null && !message.trim().isEmpty()) { %>
                <div class="mb-6 p-4 rounded-lg <%= "error".equals(type) ? "bg-red-50 border border-red-200 text-red-700 dark:bg-red-900/20 dark:border-red-800 dark:text-red-400" : "bg-green-50 border border-green-200 text-green-700 dark:bg-green-900/20 dark:border-green-800 dark:text-green-400" %>">
                    <div class="flex items-center">
                        <span class="text-xl mr-2"><%= "error".equals(type) ? "⚠️" : "✅" %></span>
                        <span><%= message %></span>
                    </div>
                </div>
                <% } %>

                <form action="login" method="post" class="space-y-6">
                    <div class="space-y-4">
                        <div class="relative">
                            <input type="text" 
                                   name="username" 
                                   placeholder="아이디 또는 이메일" 
                                   required
                                   class="w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500 outline-none transition-all duration-200 placeholder-gray-400 bg-white dark:bg-gray-700 text-black dark:text-white">
                        </div>
                        
                        <div class="relative">
                            <input type="password" 
                                   name="password" 
                                   placeholder="비밀번호" 
                                   required
                                   class="w-full px-4 py-3 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500 outline-none transition-all duration-200 placeholder-gray-400 bg-white dark:bg-gray-700 text-black dark:text-white">
                        </div>
                    </div>

                    <button type="submit" 
                            class="w-full bg-gradient-to-r from-purple-600 to-pink-600 hover:from-purple-700 hover:to-pink-700 text-white font-medium py-3 px-4 rounded-lg transition-all duration-200 transform hover:scale-[1.02] focus:ring-4 focus:ring-purple-300 shadow-lg">
                        로그인
                    </button>
                </form>

                <div class="relative my-8">
                    <div class="absolute inset-0 flex items-center">
                        <div class="w-full border-t border-gray-300 dark:border-gray-600"></div>
                    </div>
                    <div class="relative flex justify-center text-sm">
                        <span class="px-4 bg-white dark:bg-gray-800 text-gray-500 dark:text-gray-400">또는</span>
                    </div>
                </div>

                <div class="text-center">
                    <a href="signup.jsp" 
                       class="text-gray-600 dark:text-gray-400 hover:text-purple-600 dark:hover:text-purple-400 text-sm transition-colors duration-200 hover:underline">
                        계정이 없으신가요? <span class="font-medium text-purple-600 dark:text-purple-400">회원가입</span>
                    </a>
                </div>

                <div class="mt-6 text-center">
                    <a href="index.jsp" class="text-xs text-gray-500 dark:text-gray-400 hover:text-purple-600 dark:hover:text-purple-400 transition-colors duration-200">
                        메인 페이지로 돌아가기
                    </a>
                </div>
            </div>
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

