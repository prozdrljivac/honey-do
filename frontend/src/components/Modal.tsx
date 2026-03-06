import { useEffect, useRef, type ReactNode } from 'react';

interface ModalProps {
  isOpen: boolean;
  onClose: () => void;
  title: string;
  children: ReactNode;
}

export function Modal({ isOpen, onClose, title, children }: ModalProps) {
  const dialogRef = useRef<HTMLDialogElement>(null);
  const previousFocusRef = useRef<HTMLElement | null>(null);

  useEffect(() => {
    const dialog = dialogRef.current;
    if (!dialog) return;

    if (isOpen) {
      previousFocusRef.current = document.activeElement as HTMLElement | null;
      dialog.showModal();
    } else {
      dialog.close();
      previousFocusRef.current?.focus();
    }
  }, [isOpen]);

  useEffect(() => {
    const dialog = dialogRef.current;
    if (!dialog) return;

    function handleCancel(e: Event) {
      e.preventDefault();
      onClose();
    }

    dialog.addEventListener('cancel', handleCancel);
    return () => dialog.removeEventListener('cancel', handleCancel);
  }, [onClose]);

  if (!isOpen) return null;

  return (
    <dialog
      ref={dialogRef}
      className="backdrop:bg-black/40 bg-transparent p-0 m-0 max-w-none max-h-none w-full h-full"
      onClick={(e) => {
        if (e.target === dialogRef.current) onClose();
      }}
    >
      <div className="flex items-center justify-center min-h-full p-4">
        <div
          className="bg-white rounded-2xl shadow-lg border border-cocoa-100 p-6 w-full max-w-md animate-in fade-in"
          onClick={(e) => e.stopPropagation()}
        >
          <h2 className="text-xl font-bold text-cocoa-900 mb-4">{title}</h2>
          {children}
        </div>
      </div>
    </dialog>
  );
}
