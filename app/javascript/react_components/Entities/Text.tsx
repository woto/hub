import * as React from 'react';

export default function Text(props: {title: any}) {
  return (
    <div className={`tw-bg-white tw-p-1 tw-flex tw-justify-center tw-items-center`}>
      {props.title}
    </div>
  )
}