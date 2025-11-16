import { useMemo } from 'react';

export default function App({
  bg,
  children,
}: {
  bg: 'home' | 'game' | undefined;
  children: React.ReactNode;
}) {
  const classNames = useMemo(() => ([
    bg == 'game' ? 'AppGame' : 'AppHome',
  ]), [bg]);

  return (
    <div className={classNames.join(' ')}>
      {children}
    </div>
  )
}
