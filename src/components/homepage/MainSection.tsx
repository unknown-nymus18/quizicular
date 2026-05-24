import { ReactNode } from "react";
import "../../App.css";

interface Props {
  children: ReactNode;
}

function MainSection({ children }: Props) {
  return <main className="main-section">{children}</main>;
}

export default MainSection;
