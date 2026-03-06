import type { ButtonHTMLAttributes } from 'react';
import { LoadingSpinner } from './LoadingSpinner';

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary';
  isLoading?: boolean;
}

const variantClasses = {
  primary:
    'bg-honey-500 hover:bg-honey-600 text-cocoa-900 font-semibold',
  secondary:
    'bg-cocoa-100 hover:bg-cocoa-200 text-cocoa-700',
};

export function Button({
  variant = 'primary',
  isLoading = false,
  disabled,
  children,
  className = '',
  ...props
}: ButtonProps) {
  const isDisabled = disabled || isLoading;

  return (
    <button
      disabled={isDisabled}
      className={`rounded-xl px-6 py-3 transition-colors duration-200 inline-flex items-center justify-center gap-2 ${variantClasses[variant]} ${isDisabled ? 'opacity-50 cursor-not-allowed' : ''} ${className}`}
      {...props}
    >
      {isLoading && <LoadingSpinner size="sm" />}
      {children}
    </button>
  );
}
