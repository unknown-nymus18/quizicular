import "../styles/Footer.css";
import linkedInImg from "../assets/images/linkedin-icon.png";
import GithubImg from "../assets/images/github-icon.png";
// import { Component } from "@/components/ui/etheral-shadow";

function Footer() {
  return (
    <footer>
      <div className="footer-section">
        <div className="socials-section">
          <p>Felix Yamoah Asante</p>
          <div className="socials">
            <a>
              <img src={linkedInImg} />
            </a>
            <a>
              <img src={GithubImg} />
            </a>
          </div>
        </div>
        <div className="contact-section">
          <p>Contact me</p>
          <a href="mailto:felixasante2005@gmail.com">
            felixasante2005@gmail.com
          </a>
          <a href="tel:0509923363">+233 509 923 363</a>
          <a href="https://unknownnymus.dev/" target="_blank">
            unknownnymus.dev
          </a>
        </div>
      </div>
      <div className="footer-bottom">
        <p>© 2026 Quizicular Inc. All rights reserved.</p>
      </div>
    </footer>
  );
}

export default Footer;
