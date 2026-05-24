import CustomButton from "./ui/CustomButton";
import "../styles/PageNotFound.css";
import LottieAnimation from "./ui/LottieAnimation";
import pageNotFoundAnimation from "../assets/animations/404-error.json";
import { useNavigate } from "react-router-dom";
function PageNotFound() {
  const navigate = useNavigate();
  return (
    <div className="pnf">
      <LottieAnimation
        animationData={pageNotFoundAnimation}
        width={window.innerWidth}
        height={window.innerHeight - 100}
        className="page-not-found"
      ></LottieAnimation>
      <CustomButton
        onClick={() => {
          navigate("/");
        }}
      >
        Go home
      </CustomButton>
    </div>
  );
}

export default PageNotFound;
