import * as React from 'react';
import TimeAgo from '../../TimeAgo';

export default function MentionDate(props: {mentionDate: Date}) {
  if (props.mentionDate == null) return;

  return (
    <>
      {' '}
      и датой публикации
      {' '}
      <TimeAgo datetime={props.mentionDate} />
    </>
  );
}
