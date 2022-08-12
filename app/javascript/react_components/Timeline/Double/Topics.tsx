import * as React from "react";
import Wrapper from "../Wrappers/Wrapper";
import Operation from '../Wrappers/Operation';
import Tag from '../../Entities/Tag';

export default function Topics(props: { topics: any }) {
  if (!props.topics) return;

  return (
    <Wrapper title='теги'>
      {props.topics.add && props.topics.add.length > 0 &&
        props.topics.add.map((topic: any) =>
          <Operation type='append' key={topic.id}>
            <Tag linkify={false} textColor='tw-text-indigo-800' bgColor='tw-bg-indigo-200' tag={topic}></Tag>
          </Operation>
        )
      }
      {props.topics.remove && props.topics.remove.length > 0 &&
        props.topics.remove.map((topic: any) =>
          <Operation type='remove' key={topic.id}>
            <Tag linkify={false} textColor='tw-text-indigo-800' bgColor='tw-bg-indigo-200' tag={topic}></Tag>
          </Operation>
        )
      }
    </Wrapper>
  )
}
