


# hms_role library






    *[<Null safety>](https://dart.dev/null-safety)*



<p><code>Role</code> is a powerful concept that takes a lot of complexity away in handling permissions and supporting features like breakout rooms.</p>
<p>Each HMSPeer instance has a role property which returns an <a href="../model_hms_role/HMSRole-class.md">HMSRole</a> instance. You can use this property to do following:</p>
<p>1.Check what this role is allowed to publish. i.e can it send video (and at what resolution)? can it send audio? can it share screen? Who can this role subscribe to? (eg: student can only see the teacher's video) This is can be discovered by checking publishSettings and subscribeSettings properties.</p>
<p>2.Check what actions this role can perform. i.e can it change someone else's current role, end meeting, remove someone from the room. This is can be discovered by checking the permissions property.</p>
<p><a href="../model_hms_role/HMSRole-class.md">HMSRole</a> contains details about the role.</p>


## Classes

##### [HMSRole](../model_hms_role/HMSRole-class.md)



 















