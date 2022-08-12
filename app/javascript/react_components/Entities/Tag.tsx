import * as React from "react";

export default function Tag(props: { tag: any, textColor: string, bgColor: string, linkify: boolean }) {
  const textOrLink = () => {
    if (props.linkify) {
      try {
        const url = new URL(props.tag.title);
        return (
          <a href={props.tag.title}>
            {url.hostname}
          </a>)
      } catch (err) {
        return props.tag.title
      }
    } else {
      return props.tag.title;
    }
  }

  return (
    <div className={`${props.textColor} ${props.bgColor} tw-select-all tw-max-w-[200px] tw-text-ellipsis 
                     tw-truncate tw-inline tw-items-center tw-px-2 tw-py-0.5 tw-rounded tw-text-xs tw-font-medium`}>
      {textOrLink()}
    </div>
  )
}