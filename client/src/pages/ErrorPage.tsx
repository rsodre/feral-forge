import { useMemo } from 'react';
import { useRouteError } from 'react-router';
import { Flex, Heading, Text, Link, Separator } from '@radix-ui/themes';

//
// REF:
// https://reactrouter.com/6.28.1/route/error-element
//

export default function ErrorPage() {
  const error = useRouteError();
  const errorStatus = useMemo(() => (error as { status: number }).status, [error]);

  const { title, message } = useMemo(() => {
    if (errorStatus === 404) {
      return { title: '404: Page not found', message: null };
    }
    if (errorStatus) {
      return { 
        title: `A ${errorStatus} server error occurred`, 
        message: null 
      };
    }
    return { title: 'A client error occurred', message: null };
  }, [errorStatus]);

  const handleLinkClick = (e: React.MouseEvent<HTMLAnchorElement>) => {
    e.preventDefault();
    window.location.href = '/';
  };

  return (
    <Flex
      direction="column"
      align="center"
      justify="center"
      gap="4"
      style={{
        minHeight: '100vh',
        padding: '2rem',
      }}
    >
      <Flex direction="column" align="center" gap="4" style={{ maxWidth: '600px', textAlign: 'center' }}>
        <Separator size="4" />
        
        <Heading size="7" weight="bold">
          {title}
        </Heading>
        {message && (
          <Text size="3" color="gray">
            {message}
          </Text>
        )}
        
        {/* <Text size="3">If the error persists, please <Link href='/help#connect'>contact us</Link></Text> */}
        
        <Separator size="4" />
        
        <Link
          href="/"
          onClick={handleLinkClick}
          size="4"
          weight="medium"
        >
          Back to the Forge
        </Link>
      </Flex>
    </Flex>
  );
};
