<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    Integer userId = (Integer) session.getAttribute("user_id");

    if (username == null || userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko" class="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시글 작성</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    animation: {
                        'fade-in': 'fadeIn 0.5s ease-in-out',
                        'slide-up': 'slideUp 0.5s ease-out',
                    },
                    keyframes: {
                        fadeIn: {
                            '0%': { opacity: '0' },
                            '100%': { opacity: '1' }
                        },
                        slideUp: {
                            '0%': { transform: 'translateY(20px)', opacity: '0' },
                            '100%': { transform: 'translateY(0)', opacity: '1' }
                        }
                    }
                }
            }
        }
    </script>
    <style>
        @keyframes fadeIn {
            0% { opacity: 0; }
            100% { opacity: 1; }
        }
        @keyframes slideUp {
            0% { transform: translateY(20px); opacity: 0; }
            100%: { transform: translateY(0); opacity: 1; }
        }
        .custom-file-input {
            border: 1px solid #e5e7eb;
            padding: 0.75rem;
            border-radius: 0.375rem;
            background: #f9fafb;
            width: 100%;
        }
        .custom-file-input:hover {
            background: #f3f4f6;
        }
    </style>
</head>
<body class="min-h-screen bg-gray-50 text-gray-900 font-sans flex justify-center items-center animate-fade-in">
    <div class="w-full max-w-md px-4">
        <div class="bg-white rounded-xl shadow-lg p-8 animate-slide-up">
            <h2 class="text-2xl font-bold text-center mb-8 text-gray-800">게시글 작성</h2>
            <form action="writePost" method="post" enctype="multipart/form-data" class="space-y-6">
                <input type="text" name="title" placeholder="제목" required
                    class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition">
                <input type="text" name="address" placeholder="주소" required
                    class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition">
                <div class="custom-file-input">
                    <label class="block text-sm font-medium text-gray-700 mb-1">이미지 업로드</label>
                    <input type="file" name="photo" accept="image/*"
                        class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-md file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100">
                </div>
                <textarea name="content" placeholder="내용을 입력하세요" rows="6" required
                    class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition"></textarea>
                <button type="submit"
                    class="w-full py-3 px-4 bg-blue-600 hover:bg-blue-700 text-white font-bold rounded-lg transition duration-200">
                    작성 완료
                </button>
            </form>
            <a href="list.jsp"
                class="block mt-6 text-center text-blue-600 hover:text-blue-800 hover:underline transition">
                ← 목록으로 돌아가기
            </a>
        </div>
    </div>
</body>
</html>
