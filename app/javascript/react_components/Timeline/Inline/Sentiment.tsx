import * as React from "react"

import {ThumbDownIcon, ThumbUpIcon} from "@heroicons/react/outline";

export default function Sentiment(props: {sentiment: number}) {
  if (props.sentiment == null) return;

  const sentimentToString = () => {
    switch (props.sentiment) {
      case 0:
        return <ThumbUpIcon className="tw-inline tw-align-top tw-h-4 tw-w-4"></ThumbUpIcon>
      case 1:
        return <ThumbDownIcon className="tw-inline tw-align-top tw-h-4 tw-w-4"></ThumbDownIcon>
    }
  }

  return (
    <>
      {' '}
      с настроением {sentimentToString() }
    </>
  )
}