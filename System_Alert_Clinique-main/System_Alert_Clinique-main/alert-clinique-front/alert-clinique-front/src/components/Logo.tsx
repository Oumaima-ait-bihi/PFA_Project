interface LogoProps {
  size?: 'sm' | 'md' | 'lg';
  showTagline?: boolean;
  className?: string;
  showText?: boolean;
}

export function Logo({ size = 'md', showTagline = false, showText = true, className = '' }: LogoProps) {
  const iconSizes = {
    sm: 'w-12 h-12',
    md: 'w-20 h-20',
    lg: 'w-24 h-24',
  };

  const textSizes = {
    sm: 'text-base',
    md: 'text-xl',
    lg: 'text-2xl',
  };

  const taglineSizes = {
    sm: 'text-xs',
    md: 'text-sm',
    lg: 'text-base',
  };

  return (
    <div className={`flex flex-col items-center ${className}`}>
      {/* Logo Icon - ECG line with stethoscope */}
      <div className={`relative ${iconSizes[size]} mb-${showText ? '3' : '0'}`}>
        {/* ECG Line - Blue */}
        <svg
          viewBox="0 0 120 50"
          className="absolute top-0 left-0 w-full h-full"
          style={{ zIndex: 1 }}
        >
          <path
            d="M 5 25 L 15 10 L 25 25 L 35 8 L 45 25 L 55 12 L 65 28 L 75 20 L 85 30 L 95 22 L 105 28 L 115 25"
            stroke="#1e3a8a"
            strokeWidth="3"
            fill="none"
            strokeLinecap="round"
            strokeLinejoin="round"
          />
        </svg>
        
        {/* Stethoscope - Green */}
        <div className="absolute inset-0 flex items-center justify-center">
          <svg
            viewBox="0 0 120 50"
            className="w-full h-full"
            style={{ zIndex: 2 }}
          >
            {/* Earpieces aligned with ECG peaks */}
            <circle cx="15" cy="10" r="4" fill="#22c55e" stroke="#16a34a" strokeWidth="1.5" />
            <circle cx="35" cy="8" r="4" fill="#22c55e" stroke="#16a34a" strokeWidth="1.5" />
            
            {/* Tubing - curved down */}
            <path
              d="M 15 10 Q 25 20 25 30 Q 25 35 25 40"
              stroke="#22c55e"
              strokeWidth="3"
              fill="none"
              strokeLinecap="round"
            />
            <path
              d="M 35 8 Q 25 20 25 30 Q 25 35 25 40"
              stroke="#22c55e"
              strokeWidth="3"
              fill="none"
              strokeLinecap="round"
            />
            
            {/* Chest piece */}
            <circle cx="25" cy="40" r="6" fill="#22c55e" stroke="#16a34a" strokeWidth="2" />
            <circle cx="25" cy="40" r="3" fill="#1e3a8a" />
          </svg>
        </div>
      </div>

      {/* Clinic Name */}
      {showText && (
        <div className="text-center">
          <h1 className={`font-bold text-green-600 ${textSizes[size]}`}>
            MediCure Clinic
          </h1>
          {showTagline && (
            <p className={`text-blue-800 mt-1 ${taglineSizes[size]}`}>
              —Your Partner in Health—
            </p>
          )}
        </div>
      )}
    </div>
  );
}

