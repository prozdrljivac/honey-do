const colorMap: Record<string, string> = {
  pending: 'bg-honey-100 text-honey-800',
  'in-progress': 'bg-blue-100 text-blue-800',
  done: 'bg-green-100 text-green-800',
};

const fallbackColor = 'bg-cocoa-100 text-cocoa-700';

interface StatusBadgeProps {
  status: string;
}

export function StatusBadge({ status }: StatusBadgeProps) {
  const colors = colorMap[status] ?? fallbackColor;

  return (
    <span className={`rounded-full px-3 py-1 text-sm font-medium inline-block ${colors}`}>
      {status}
    </span>
  );
}
