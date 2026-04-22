<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>사업자 회원가입</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <style>
        body {
            margin: 0;
            padding: 60px 0;
            background: #f4f6fb;
            font-family: Arial, sans-serif;
        }

        #app {
            width: 520px;
            margin: 0 auto;
            background: #f0f4f5;
            border: 1px solid hsl(205, 89%, 51%);
            border-radius: 16px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
            padding: 28px 24px 24px;
        }

        #app::before {
            content: "사업자 회원가입";
            display: block;
            font-size: 22px;
            font-weight: 700;
            color: #222;
            margin-bottom: 24px;
            text-align: center;
        }

        .row {
            margin-bottom: 12px;
        }

        .row input {
            width: 100%;
            height: 42px;
            border: 1px solid #cfd8e3;
            border-radius: 10px;
            padding: 0 12px;
            font-size: 14px;
            box-sizing: border-box;
            background: white;
        }

        .btn-box {
            margin-top: 20px;
        }

        .btn-box button {
            width: 100%;
            height: 46px;
            border-radius: 12px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 700;
            border: 1px solid #dfd7cf;
            background: #f7f2ed;
            color: #2b2b2b;
            transition: all 0.2s ease;
        }

        .btn-box button:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        }

        .link-box {
            text-align: center;
            margin-top: 14px;
        }

        .link-box a {
            color: #333;
            text-decoration: none;
            margin: 0 6px;
            font-size: 14px;
        }
    </style>
</head>
<body>
<div id="app">
    <div class="row"><input type="text