import { useEffect, useState } from "react";
import NavBar from "./components/NavBar";
import MainSection from "./components/homepage/MainSection";
import Hero from "./components/homepage/Hero";
import "./App.css";
import FeaturesSection from "./components/homepage/FeaturesSection";
import Footer from "./components/Footer";
import CreateAccSection from "./components/homepage/CreateAccSection";
import AuthApi from "./scripts/AuthApi";
import Quizicular from "./assets/animations/Quizicular.json";
import LottieAnimation from "./components/ui/LottieAnimation";

interface User {
  id: number;
  username: string;
  email: string;
  first_name: string;
  last_name: string;
  is_authenticated: boolean;
  profile: {
    streak: number;
    quizzes_completed: number;
    total_score: number;
  };
}

function App() {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [animationComplete, setAnimationComplete] = useState(false);

  const checkAuthentication = async () => {
    setIsLoading(true);
    try {
      const response = await AuthApi.checkAuth();
      if (response) {
        setUser(response); // AuthApi.checkAuth() returns user directly or null
        console.log(response);
      } else {
        setUser(null);
      }
    } catch (error) {
      setUser(null);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    checkAuthentication();
  }, []);

  // return animationComplete ? (
  //   <div className="homepage-shell">
  //     <NavBar user={user} onUserChange={checkAuthentication} />
  //     <MainSection>
  //       <Hero user={user} onUserChange={checkAuthentication}></Hero>
  //       <FeaturesSection></FeaturesSection>
  //     </MainSection>
  //     <CreateAccSection></CreateAccSection>
  //     <Footer></Footer>
  //   </div>
  // ) : (
  //   null
  //   // <LottieAnimation
  //   //   animationData={Quizicular}
  //   //   height={window.innerHeight}
  //   //   width={window.innerWidth}
  //   //   loop={false}
  //   //   onAnimationComplete={() => {
  //   //     setAnimationComplete(true);
  //   //   }}
  //   // ></LottieAnimation>
  // );
  return (
    <div className="homepage-shell">
      <NavBar user={user} onUserChange={checkAuthentication} />
      <MainSection>
        <Hero user={user} onUserChange={checkAuthentication}></Hero>
        <FeaturesSection></FeaturesSection>
      </MainSection>
      <CreateAccSection></CreateAccSection>
      <Footer></Footer>
    </div>
  );
}

export default App;
