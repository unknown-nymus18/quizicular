import React, { useEffect, useState } from 'react';
import '../../styles/ui/AnimatedGrid.css';

const AnimatedGrid: React.FC = () => {
  const [particles, setParticles] = useState<{ id: number; left: string; delay: string; duration: string }[]>([]);

  useEffect(() => {
    const newParticles = Array.from({ length: 20 }).map((_, i) => ({
      id: i,
      left: `${Math.random() * 100}%`,
      delay: `${Math.random() * 10}s`,
      duration: `${10 + Math.random() * 10}s`,
    }));
    setParticles(newParticles);
  }, []);

  return (
    <div className="grid-container">
      <div className="grid-background"></div>
      <div className="moving-grid"></div>
      <div className="grid-beam"></div>
      <div className="grid-glow"></div>
      <div className="grid-particles">
        {particles.map((p) => (
          <div
            key={p.id}
            className="particle"
            style={{
              left: p.left,
              animationDelay: p.delay,
              animationDuration: p.duration,
            }}
          ></div>
        ))}
      </div>
    </div>
  );
};

export default AnimatedGrid;
