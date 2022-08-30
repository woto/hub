import * as React from "react";
import Single from "./Single";
import {TagObject} from '../system/TypeScript'

export default function Multiple(props: { tags: TagObject[], textColor: string, bgColor: string, linkify: boolean }) {
  return (
    <div className='tw-flex tw-flex-wrap tw-gap-1'>
      {props.tags.map((tag) => {
        return <Single tag={tag} textColor={props.textColor} bgColor={props.bgColor} linkify={props.linkify}></Single>
      })}
    </div>
  )
}