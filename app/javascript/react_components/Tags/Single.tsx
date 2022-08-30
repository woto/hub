import * as React from "react";
import {TagObject} from '../system/TypeScript'

export default function Single(props: { tag: TagObject, textColor: string, bgColor: string, linkify: boolean }) {

  const textOrLink = () => {
    if (props.tag.url) {
      return (
        <a href={props.tag.url}>
          {props.tag.title}
        </a>
      )
    } else if (props.linkify) {
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

// TODO: truncate www
// @text_tag.gsub(/\A(https:\/\/|http:\/\/)/, '').gsub(/\Awww\./, '').gsub(/\/\z/, ''), @text_tag,
//     rel: [Seo::NoReferrer, Seo::NoFollow, Seo::UGC]

  return (
    <div className={`${props.textColor} ${props.bgColor} tw-select-all tw-max-w-[200px] tw-text-ellipsis 
                     tw-truncate tw-inline-block tw-items-center tw-px-2 tw-py-0.5 tw-rounded tw-text-xs tw-font-medium`}>
      {textOrLink()}
    </div>
  )
}