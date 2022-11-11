import * as React from 'react';
import Single from './Single';
import { TagObject } from '../system/TypeScript';

export default function Multiple(props: {
  tags: TagObject[],
  textColor: string,
  bgColor: string,
  linkify: boolean,
  limit: number
}) {
  const {
    textColor, bgColor, linkify, limit, tags,
  } = props;

  return (
    <div className="tw-flex tw-flex-wrap tw-gap-1">
      {tags.slice(0, limit).map((tag) => (
        <Single
          tag={tag}
          key={tag.title}
          textColor={textColor}
          bgColor={bgColor}
          linkify={linkify}
        />
      ))}
    </div>
  );
}
