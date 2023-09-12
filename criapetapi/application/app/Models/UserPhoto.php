<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UserPhoto extends Model
{
    use HasFactory;
    protected $table = 'UserPhoto';

    protected $fillable = ['user_id', 'url'];

    protected $hidden = ['url'];
}
