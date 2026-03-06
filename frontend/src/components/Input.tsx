import { useId, type InputHTMLAttributes } from 'react';

interface InputProps extends InputHTMLAttributes<HTMLInputElement> {
  label: string;
  error?: string;
}

export function Input({ label, error, className = '', ...props }: InputProps) {
  const generatedId = useId();
  const inputId = props.id ?? generatedId;

  return (
    <div className="flex flex-col gap-1.5">
      <label htmlFor={inputId} className="text-sm font-medium text-cocoa-700">
        {label}
      </label>
      <input
        id={inputId}
        className={`bg-white border ${error ? 'border-red-500' : 'border-cocoa-200'} focus:border-honey-500 focus:ring-2 focus:ring-honey-200 rounded-xl px-4 py-3 outline-none transition-all text-cocoa-900 ${className}`}
        aria-invalid={error ? 'true' : undefined}
        aria-describedby={error ? `${inputId}-error` : undefined}
        {...props}
      />
      {error && (
        <p id={`${inputId}-error`} className="text-sm text-red-600">
          {error}
        </p>
      )}
    </div>
  );
}
