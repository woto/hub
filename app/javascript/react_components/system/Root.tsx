import {Fragment} from 'react';
import * as React from 'react';
import * as ReactDOM from 'react-dom';

import Carousel from '../Carousel/Index'
import SearchBar from "../SearchBar";
import Language from '../Dropdown/Language'
import Bookmark from '../Bookmark'
import Mentions from '../Mentions'
import EntitiesBadge from '../Entities/Badge'
import EntitiesButtons from '../Entities/Buttons'
import EntitiesReport from '../Entities/Report'
import TimeAgo from '../TimeAgo'
import User from '../User'
import EntitiesEditLink from '../Entities/EditLink'
import EntitiesTimeline from '../Entities/Timeline'
import TimelineMentionDate from '../Timeline/Inline/MentionDate'
import TimelineRelevance from '../Timeline/Inline/Relevance'
import TimelineSentiment from '../Timeline/Inline/Sentiment'
import TimelineImages from '../Timeline/Double/Images'
import TimelineIntro from '../Timeline/Double/Intro'
import TimelineLookups from '../Timeline/Double/Lookups'
import TimelineTitle from '../Timeline/Double/Title'
import TimelineTopics from '../Timeline/Double/Topics'
import TimelineWrapper from '../Timeline/Wrappers/Wrapper'
import EntitiesTag from '../Entities/Tag'
import Tinder from '../Tinder/Index';
import MentionsFilter from './../Filters'

const Portal = ({ Component, container, ...props }) => {

  const [innerHtmlEmptied, setInnerHtmlEmptied] = React.useState(false)
  React.useEffect(() => {
    if (!innerHtmlEmptied) {
      container.innerHTML = ''
      setInnerHtmlEmptied(true)
    }
  }, [innerHtmlEmptied])

  if (!innerHtmlEmptied) return null

  return ReactDOM.createPortal(<Component {...props} />, container)
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
  let tests = document.querySelectorAll('[data-react]');

  let components = {
    Language,
    SearchBar,
    Bookmark,
    Mentions,
    EntitiesBadge,
    Carousel,
    EntitiesReport,
    EntitiesButtons,
    MentionsFilter,
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
    EntitiesTag,
    Tinder
  }

  return (
    <Fragment>
      { Array.from(tests).map((element: HTMLElement, index: number) => {
          // element.className = '';
          let props = JSON.parse(element.dataset['props']);
          let name = element.dataset['react'];
          let Component = components[name];

          if (!Component) alert(`Component ${name} not found, check imports in Root.tsx`);

          return (
            <Portal key={index} Component={Component} container={element} {...props} />
            // <Component key={index} {...props}></Component>
          )
        })
      }
    </Fragment>
  )
}
