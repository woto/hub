import { Fragment } from 'react';
import * as React from 'react';
import * as ReactDOM from 'react-dom';

import Alert from '../Alert';
import Complain from '../Complain';
import Carousel from '../Carousel/Carousel';
import Language from '../Language';
import EntitiesBadge from '../Entities/Badge';
// import EntitiesCircles from '../Entities/Circles'
import EntitiesButtons from '../Entities/Buttons';
import TimeAgo from '../TimeAgo';
import User from '../User';
import EntitiesEditLink from '../Entities/EditLink';
import EntitiesTimeline from '../Entities/Timeline';
import TimelineMentionDate from '../Timeline/Inline/MentionDate';
import TimelineRelevance from '../Timeline/Inline/Relevance';
import TimelineSentiment from '../Timeline/Inline/Sentiment';
import TimelineImages from '../Timeline/Double/Images';
import TimelineIntro from '../Timeline/Double/Intro';
import TimelineLookups from '../Timeline/Double/Lookups';
import TimelineTitle from '../Timeline/Double/Title';
import TimelineTopics from '../Timeline/Double/Topics';
import TimelineWrapper from '../Timeline/Wrappers/Wrapper';
import SingleTag from '../Tags/Single';
import MultipleTags from '../Tags/Multiple';
import Tinder from '../Tinder/Index';
import Interaction from '../Mentions/Interaction';
import Mentions from '../Mentions/Mentions';
import MentionsFilter from '../Filters/Index';
import MentionsImage from '../Mentions/Image';
import MentionsCard from '../Mentions/MentionsItem1';
import DesktopSidebar from '../Sidebar/DesktopSidebar';
import MobileSidebar from '../Sidebar/MobileSidebar';
import Hamburger from '../Sidebar/Hamburger';
// import SetUser from '../Auth/SetUser';
import AuthProvider from '../Auth/AuthProvider';
import SidebarProvider from '../Sidebar/SidebarProvider';
import LanguageProvider from '../Language/LanguageProvider';
import ListingEntities from '../Listings/ListingEntities';
import ListingMentions from '../Listings/ListingMentions';
import Tabs from '../User/Tabs';

function Portal({ Component, container, ...props }) {
  const [innerHtmlEmptied, setInnerHtmlEmptied] = React.useState(false);
  React.useEffect(() => {
    if (!innerHtmlEmptied) {
      container.innerHTML = '';
      setInnerHtmlEmptied(true);
    }
  }, [innerHtmlEmptied]);

  if (!innerHtmlEmptied) return null;

  return ReactDOM.createPortal(<Component {...props} />, container);
}

// export const Portal = (props: {root: Element}) => {
//   const el = useRef(document.createElement('div'));
//
//   useEffect(() => {
//     const current = el.current;
//     // We assume `root` exists with '?'
//     if (!props.root?.hasChildNodes()) {
//       props.root?.appendChild(current);
//     }
//
//     return () => void props.root?.removeChild(current);
//   }, []);
//
//   return createPortal(props.children, el.current);
// };

export default function Root() {
  const tests = document.querySelectorAll('[data-react]');

  const components = {
    MobileSidebar,
    DesktopSidebar,
    Hamburger,
    // SetUser,
    Alert,
    Complain,
    Language,
    EntitiesBadge,
    // EntitiesCircles,
    Carousel,
    EntitiesButtons,
    TimeAgo,
    User,
    EntitiesEditLink,
    EntitiesTimeline,
    TimelineMentionDate,
    TimelineRelevance,
    TimelineSentiment,
    TimelineImages,
    TimelineIntro,
    TimelineLookups,
    TimelineTitle,
    TimelineTopics,
    TimelineWrapper,
    SingleTag,
    MultipleTags,
    Tinder,
    Interaction,
    ListingEntities,
    ListingMentions,
    Mentions,
    MentionsImage,
    MentionsCard,
    MentionsFilter,
    Tabs,
  };

  return (
    <AuthProvider>
      <LanguageProvider>
        <SidebarProvider>
          {Array.from(tests).map((element: HTMLElement, index: number) => {
            // element.className = '';
            const props = JSON.parse(element.dataset.props);
            const name = element.dataset.react;
            const Component = components[name];

            if (!Component) alert(`Component ${name} not found, check imports in Root.tsx`);

            return (
              <Portal key={index} Component={Component} container={element} {...props} />
              // <Component key={index} {...props}></Component>
            );
          })}
        </SidebarProvider>
      </LanguageProvider>
    </AuthProvider>
  );
}
