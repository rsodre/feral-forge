import { Button } from '@radix-ui/themes'

export function MenuButton({
  size = '3',
  onClick,
  disabled,
  children,
}: {
  size?: '1' | '2' | '3';
  disabled?: boolean;
  onClick: () => void;
  children: React.ReactNode | string;
}) {
  return (
    <Button size={size} style={{ width: '200px' }} onClick={onClick} disabled={disabled}>{children}</Button>
  )
}
