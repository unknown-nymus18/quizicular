import { ReactNode } from "react";
import "../App.css";
interface Props {
  children: ReactNode;
}
function Subtitle({ children }: Props) {
  return <p className="subtitle">{children}</p>;
}

export default Subtitle;
