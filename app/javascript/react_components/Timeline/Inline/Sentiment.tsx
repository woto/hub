import * as React from "react"

import {HandThumbDownIcon, HandThumbUpIcon} from "@heroicons/react/24/outline";

export default function Sentiment(props: {sentiment: number}) {
  if (props.sentiment == null) return;

  const sentimentToString = () => {
    switch (props.sentiment) {
      case 0:
        return <HandThumbDownIcon className="tw-inline tw-align-top tw-h-4 tw-w-4"></HandThumbDownIcon>
      case 1:
        return <HandThumbUpIcon className="tw-inline tw-align-top tw-h-4 tw-w-4"></HandThumbUpIcon>
    }
  }

  return (
    <>
      {' '}
      с настроением {sentimentToString() }
    </>
  )
}