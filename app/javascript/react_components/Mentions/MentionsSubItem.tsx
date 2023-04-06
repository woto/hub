import * as React from 'react';
import { ClockIcon } from '@heroicons/react/24/outline';
import { ArrowTopRightOnSquareIcon } from '@heroicons/react/20/solid';
import TimeAgo from '../TimeAgo';
import Multiple from '../Tags/Multiple';
import Image from './Image';
import Interaction from './Interaction';
import Carousel from '../Carousel/Carousel';

function Url({ url }: { url: string }) {
  let parsedUrl;

  try {
    parsedUrl = new URL(url);
  } catch (e) {
    return null;
  }

  return (
    <span className="tw-text-sm tw-font-mono tw-text-white">
      {parsedUrl.hostname}
    </span>
  );
}

function Title({ title }: { title: string }) {
  if (title) {
    return (
      <span className="tw-text-white">
        {title}
      </span>
    );
  }
}

function Icon() {
  return (
    <span className="">
      <ArrowTopRightOnSquareIcon className="tw-inline tw-w-3.5 tw-h-3.5" />
    </span>
  );
}

function MentionsSubItem(
  {
    url, title, publishedAt, topics, image, entities, mentionId, slug,
  }:
  {
    url: string,
    title: string,
    publishedAt: Date,
    topics: any[],
    image: any,
    entities: any[],
    mentionId: string,
    slug: string,
  },
) {
  return (
    <div className="tw-flex tw-rounded-lg tw-flex-col tw-space-y-5">
      <div className="tw-flex tw-shrink tw-p-3 2xl:tw-p-3.5 2xl:tw-text-lg tw-bg-slate-600 hover:tw-bg-sky-800 tw-rounded-lg tw-text-base">

        <a href={url} className="tw-text-slate-50 tw-font-medium">
          <Title title={title} />
            &nbsp;
          <Url url={url} />
            &nbsp;
          <Icon />
        </a>
      </div>

      {publishedAt
        && (
          <div className="tw-flex tw-items-center tw-gap-x-2 tw-text-gray-500">
            <ClockIcon className="tw-w-5 tw-h-5" />
            <TimeAgo datetime={publishedAt} />
          </div>
        )}

      {topics.length > 0
          && <Multiple tags={topics} limit={10} textColor="tw-text-blue-800" bgColor="tw-bg-blue-100" linkify={false} />}

      <div
        className="tw-flex tw-justify-end tw-flex-grow tw-relative tw-rounded-lg tw-items-stretch tw-w-full"
      >
        <Image image={image} url={url} />

        <Interaction
          mention={{
            id: mentionId, url, title, image, slug,
          }}
          entities={entities.slice(0, 1)}
        />
      </div>

      <Carousel items={entities} type="multiple" />

    </div>
  );
}

export default React.memo(MentionsSubItem);
