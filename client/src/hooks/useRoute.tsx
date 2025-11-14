import { useLocation, useParams } from 'react-router'

export const useRoute = () => {
  // URL slugs (/path/slug)
  // https://api.reactrouter.com/v7/functions/react_router.useParams.html
  const params = useParams()
  const location = useLocation()
  return {
    pathname: location.pathname,
    slugs: {
      game_id: params['game_id'],
      page_num: params['page_num'],
    },
  }
}

export const useRouteSlugs = () => {
  const { slugs } = useRoute()
  return slugs
}
