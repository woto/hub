import * as React from "react"
import Wrapper from "../Wrappers/Wrapper";
import Operation from '../Wrappers/Operation';
import SingleTag from "../../Tags/Single";

export default function Lookups(props: { lookups: any }) {
  if (!props.lookups) return;

  return (
    <Wrapper title='синонимы'>
      {props.lookups.add && props.lookups.add.length > 0 &&
        props.lookups.add.map((lookup: any) => (
          <Operation type='append' key={lookup.id}>
            <SingleTag linkify={true} textColor='tw-text-pink-800' bgColor='tw-bg-pink-200' tag={lookup}></SingleTag>
          </Operation>
        ))}
      {props.lookups.remove && props.lookups.remove.length > 0 &&
        props.lookups.remove.map((lookup: any) => (
          <Operation type='remove' key={lookup.id}>
            <SingleTag linkify={true} textColor='tw-text-pink-800' bgColor='tw-bg-pink-200' tag={lookup}></SingleTag>
          </Operation>
        ))}
    </Wrapper>
  )
}
