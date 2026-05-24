import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App";
// import "bootstrap/dist/css/bootstrap.css";

import { createBrowserRouter, RouterProvider } from "react-router-dom";
import LoginPage from "./components/login/LoginPage";
import RegisterPage from "./components/register/RegisterPage";
import LeaderBoardPage from "./components/leaderboard/LeaderBoardPage";
import PageNotFound from "./components/PageNotFound";
import QuizConfig from "./components/quiz-config/quiz-config";
import Quiz from "./components/quiz/Quiz";
import Profile from "./components/profile/Profile";

const router = createBrowserRouter([
  { path: "*", element: <PageNotFound></PageNotFound> },
  { path: "/", element: <App /> },
  { path: "/login", element: <LoginPage></LoginPage> },
  { path: "/register", element: <RegisterPage></RegisterPage> },
  { path: "/leaderboard", element: <LeaderBoardPage></LeaderBoardPage> },
  { path: "/quiz-config", element: <QuizConfig></QuizConfig> },
  { path: "quiz/:difficulty/:questionsNumber", element: <Quiz></Quiz> },
  { path: "/profile", element: <Profile></Profile> },
]);

ReactDOM.createRoot(document.getElementById("root") as HTMLElement).render(
  <React.StrictMode>
    <RouterProvider router={router}></RouterProvider>
  </React.StrictMode>,
);
